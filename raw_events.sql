-- Schema for Raw Events Table.
-- Note: Create this table schema manually when setting up the ClickPipe.
-- Otherwise, columns can be missing from the setup.
-- This file is provideed as a reference for what the schema should look like.
-- Variables: {{ database }}, {{ schema }}, {{ table_name }}
CREATE TABLE {{ database }}.{{ schema }}.{{ table_name }}
(
    -- Name of the event
    `event` String,
    -- Source of the event
    `source` String,
    -- Affiliation (e.g., brand or category)
    `affiliation` String,
    -- Source of the action
    `actionSource` String,
    -- Customer identifier
    `customerId` String,
    -- Event timestamp in milliseconds since epoch
    `timestamp` Int64,
    -- Hydration timestamp in milliseconds since epoch
    `hydrationTimestamp` Int64,
    -- Schema version for the event
    `version` String,
    -- Merchant identifier
    `merchantId` String,
    -- Source endpoint identifier
    `sourceEndpointId` String,
    -- Event properties in JSON
    `properties` String,
    -- Context payload in JSON
    `context` String,
    -- Type of the event (e.g., "track", "identify")
    `type` String,
    -- Customer payload in JSON
    `customer` String,
    -- Destination endpoint identifier
    `destinationEndpointId` String,
    -- Destination platform (e.g., Facebook, Google)
    `destinationPlatform` String,
    -- Original event name, if available
    `originalEvent` String,
    -- Checkout information in JSON
    `checkout` String,
    -- Store identifier
    `storeId` String,
    -- Order information in JSON
    `order` String
)
-- ClickHouse-specific engine for raw data
ENGINE = SharedMergeTree('/clickhouse/tables/{uuid}/{shard}', '{replica}')
-- No explicit partitioning or ordering
ORDER BY tuple()
SETTINGS index_granularity = 8192;
