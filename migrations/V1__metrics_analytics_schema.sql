-- =============================================================================
-- Diagnyx Metrics Analytics Database Schema
-- Migration: V1__metrics_analytics_schema.sql
-- =============================================================================

-- Create update_updated_at_column function if it doesn't exist
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Enable TimescaleDB extension (already done in database setup script, but included for completeness)
CREATE EXTENSION IF NOT EXISTS timescaledb CASCADE;

-- 1. Performance Metrics Tables
CREATE TABLE public.api_performance_metrics (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  api_id UUID NOT NULL,
  time_period TEXT NOT NULL,
  period_start TIMESTAMP WITH TIME ZONE NOT NULL,
  period_end TIMESTAMP WITH TIME ZONE NOT NULL,
  avg_response_time NUMERIC,
  weighted_avg_response_time NUMERIC,
  error_rate NUMERIC,
  client_error_rate NUMERIC,
  server_error_rate NUMERIC,
  network_error_rate NUMERIC,
  uptime_percentage NUMERIC,
  request_count INTEGER DEFAULT 0,
  successful_requests INTEGER DEFAULT 0,
  failed_requests INTEGER DEFAULT 0,
  p50_response_time NUMERIC,
  p75_response_time NUMERIC,
  p90_response_time NUMERIC,
  p95_response_time NUMERIC,
  p99_response_time NUMERIC,
  outliers_excluded INTEGER DEFAULT 0,
  baseline_response_time NUMERIC,
  planned_downtime_minutes INTEGER DEFAULT 0,
  anomaly_detected BOOLEAN DEFAULT false,
  trend_direction TEXT,
  seasonal_pattern TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Convert to TimescaleDB hypertable
SELECT create_hypertable('api_performance_metrics', 'period_start');

-- Create metrics aggregation table
CREATE TABLE public.metrics_aggregation (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  api_id UUID NOT NULL,
  aggregation_date DATE NOT NULL,
  aggregation_type TEXT NOT NULL,
  avg_response_time NUMERIC,
  min_response_time NUMERIC,
  max_response_time NUMERIC,
  error_rate NUMERIC,
  uptime_percentage NUMERIC,
  total_checks INTEGER DEFAULT 0,
  successful_checks INTEGER DEFAULT 0,
  failed_checks INTEGER DEFAULT 0,
  requests_per_minute NUMERIC,
  requests_per_hour NUMERIC,
  requests_per_second NUMERIC,
  peak_response_time NUMERIC,
  peak_error_rate NUMERIC,
  capacity_utilization NUMERIC,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Convert to TimescaleDB hypertable
SELECT create_hypertable('metrics_aggregation', 'aggregation_date');

-- Create system monitoring table
CREATE TABLE public.system_monitoring (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  metric_name TEXT NOT NULL,
  metric_value NUMERIC NOT NULL,
  metric_unit TEXT,
  tags JSONB DEFAULT '{}',
  timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Convert to TimescaleDB hypertable
SELECT create_hypertable('system_monitoring', 'timestamp');

-- Create metric cache table
CREATE TABLE public.metric_cache (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  cache_key TEXT NOT NULL,
  api_id UUID NOT NULL,
  time_period TEXT NOT NULL,
  cached_data JSONB NOT NULL,
  cache_expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
  hit_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create triggers for updated_at columns
CREATE TRIGGER update_api_performance_metrics_updated_at
  BEFORE UPDATE ON public.api_performance_metrics
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_metrics_aggregation_updated_at
  BEFORE UPDATE ON public.metrics_aggregation
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_metric_cache_updated_at
  BEFORE UPDATE ON public.metric_cache
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at_column();

-- Create indexes for better performance
CREATE INDEX idx_api_performance_metrics_api_id ON public.api_performance_metrics(api_id);
CREATE INDEX idx_api_performance_metrics_time_period ON public.api_performance_metrics(time_period);
CREATE INDEX idx_metrics_aggregation_api_id ON public.metrics_aggregation(api_id);
CREATE INDEX idx_metrics_aggregation_type ON public.metrics_aggregation(aggregation_type);
CREATE INDEX idx_system_monitoring_metric_name ON public.system_monitoring(metric_name);
CREATE INDEX idx_metric_cache_api_id ON public.metric_cache(api_id);
CREATE INDEX idx_metric_cache_cache_key ON public.metric_cache(cache_key);
CREATE INDEX idx_metric_cache_expires_at ON public.metric_cache(cache_expires_at); 