-- Error Logging schema
CREATE TABLE IF NOT EXISTS error_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID,
  error_message TEXT NOT NULL,
  stack_trace TEXT,
  error_code VARCHAR(100),
  component VARCHAR(255),
  browser_info JSONB,
  url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Add indexes
CREATE INDEX idx_error_logs_user ON error_logs(user_id);
CREATE INDEX idx_error_logs_created ON error_logs(created_at);
CREATE INDEX idx_error_logs_component ON error_logs(component); 