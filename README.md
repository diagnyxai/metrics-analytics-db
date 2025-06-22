# Metrics & Analytics Database

## Overview
Database repository for the Metrics & Analytics Service handling time-series data, performance metrics, and analytics.

## Database Structure

### Time-Series Tables (InfluxDB/TimescaleDB)
- `api_response_times` - Response time measurements
- `api_request_volumes` - Request volume tracking
- `api_error_rates` - Error rate metrics
- `api_uptime_data` - Uptime/downtime tracking
- `api_status_codes` - HTTP status code distribution
- `performance_baselines` - Performance baseline data

### Analytics Tables (PostgreSQL)
- `metric_aggregations` - Pre-computed aggregations
- `performance_trends` - Trend analysis data
- `anomaly_detections` - Anomaly detection results
- `sla_calculations` - SLA performance tracking
- `capacity_planning` - Capacity planning metrics

### Configuration Tables
- `metric_definitions` - Metric configuration
- `aggregation_rules` - Data aggregation rules
- `retention_policies` - Data retention configurations
- `alert_thresholds` - Metric-based alert thresholds
- `dashboard_configs` - Dashboard metric configurations

### Optimization Tables
- `metric_cache` - Frequently accessed metrics cache
- `query_optimization` - Query performance tracking
- `data_compression` - Compression statistics
- `partition_management` - Time-based partitioning info

## Technology Stack
- **Primary**: TimescaleDB (PostgreSQL + time-series)
- **Alternative**: InfluxDB for pure time-series
- **Cache**: Redis for real-time metrics
- **Features**: Automatic partitioning, compression, continuous aggregates

## Key Features
- High-performance time-series storage
- Automatic data compression and retention
- Real-time continuous aggregations
- Multi-dimensional analytics
- Horizontal scaling support

## Setup
```bash
# Create database with TimescaleDB
createdb metrics_analytics_db
psql -d metrics_analytics_db -c "CREATE EXTENSION IF NOT EXISTS timescaledb;"

# Run migrations
psql -d metrics_analytics_db -f migrations/001_initial_setup.sql
psql -d metrics_analytics_db -f migrations/002_timeseries_tables.sql
psql -d metrics_analytics_db -f migrations/003_analytics_tables.sql
psql -d metrics_analytics_db -f migrations/004_configuration_tables.sql
psql -d metrics_analytics_db -f migrations/005_optimization_tables.sql
``` 