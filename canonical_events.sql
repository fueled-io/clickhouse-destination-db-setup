-- Template for creating the canonical events table
-- Variables: {{ database }}, {{ schema }}, {{ table_name }}
CREATE TABLE {{ database }}.{{ schema }}.{{ table_name }}
(
    -- Merchant-specific identifier
    `merchantId` String,
    -- Unique event identifier
    `event_id` UInt64,
    -- Original event timestamp with millisecond precision
    `original_timestamp` DateTime64(3),
    -- Timestamp when the event was hydrated
    `hydration_timestamp` DateTime64(3),
    -- Type of the event (e.g., track, identify)
    `event_type` String,
    -- Name of the event (e.g., "Page View")
    `event_name` String,
    -- Source of the event
    `source` String,
    -- Source endpoint identifier
    `sourceEndpointId` String,
    -- Affiliation (e.g., brand or category)
    `affiliation` String,
    -- Schema version for the event
    `schema_version` String,
    -- Optional: Anonymous identifier
    `anonymousId` Nullable(String),
    -- Optional: Fueled-specific external identifier
    `fueledExternalId` Nullable(String),
    -- Optional: Session identifier
    `sessionId` Nullable(String),
    -- Optional: Customer identifier
    `customerId` Nullable(String),
    -- Optional: User identifier
    `userId` Nullable(String),
    -- Optional: Hashed email
    `email_hashed` Nullable(String),
    -- Optional: Hashed phone number
    `phone_hashed` Nullable(String),
    -- Customer payload in JSON
    `customer` Nullable(String),
    -- Context payload in JSON
    `context` Nullable(String),
    -- Event properties in JSON
    `properties` Nullable(String)
)
-- ClickHouse-specific engine for sharded tables
ENGINE = SharedMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
-- Partition data by year-month and event name for efficiency
PARTITION BY (toYYYYMM(original_timestamp), event_name)
-- Order data for optimal query performance
ORDER BY (original_timestamp, event_name, event_id)
SETTINGS index_granularity = 8192;
