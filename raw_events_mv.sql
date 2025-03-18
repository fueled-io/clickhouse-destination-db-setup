-- Template for creating a materialized view
-- Variables: {{ source_table }}, {{ target_table }}
CREATE MATERIALIZED VIEW {{ target_table }} TO {{ target_table }}
(
    -- Column definitions for the target table
    `merchantId` String,
    `event_id` UInt64,
    `original_timestamp` DateTime64(3),
    `hydration_timestamp` DateTime64(3),
    `event_type` String,
    `event_name` String,
    `source` String,
    `sourceEndpointId` String,
    `affiliation` String,
    `schema_version` String,
    `anonymousId` Nullable(String),
    `fueledExternalId` Nullable(String),
    `sessionId` Nullable(String),
    `customerId` Nullable(String),
    `userId` Nullable(String),
    `email_hashed` Nullable(String),
    `phone_hashed` Nullable(String),
    `customer` Nullable(String),
    `context` Nullable(String),
    `properties` Nullable(String)
)
AS
-- Extract values from JSON fields and transform as needed
WITH
    JSONExtractString(context, 'anonymousId') AS context_anonymousId,
    JSONExtractString(context, 'sessionId') AS context_sessionId,
    JSONExtractString(context, 'userId') AS context_userId,
    JSONExtractString(context, 'fb') AS facebook,
    coalesce(JSONExtractString(context, 'fueledExternalId'), JSONExtractString(facebook, 'externalId')) AS traits_fueledExternalId,
    JSONExtractString(context, 'traits') AS traits,
    JSONExtractString(traits, 'email') AS traits_email,
    JSONExtractString(traits, 'phone') AS traits_phone,
    JSONExtractString(customer, 'email') AS customer_email,
    JSONExtractString(customer, 'phone') AS customer_phone
SELECT
    merchantId,
    cityHash64(toDateTime64(timestamp / 1000, 3), event_name, customerId, merchantId) AS event_id,
    toDateTime64(timestamp / 1000, 3) AS original_timestamp,
    toDateTime64(hydrationTimestamp / 1000, 3) AS hydration_timestamp,
    if((type = '') OR (type IS NULL), 'track', type) AS event_type,
    multiIf(type = 'identify', 'Identify', type = 'page', 'Page View', (type = 'track') AND (originalEvent IS NOT NULL), originalEvent, (type IS NULL) OR (type = ''), event, event) AS event_name,
    source,
    sourceEndpointId,
    affiliation,
    version AS schema_version,
    nullIf(context_anonymousId, '') AS anonymousId,
    nullIf(context_sessionId, '') AS sessionId,
    nullIf(context_userId, '') AS userId,
    nullIf(customerId, '') AS customerId,
    nullIf(traits_fueledExternalId, '') AS fueledExternalId,
    nullIf(coalesce(traits_email, customer_email), '') AS email_hashed,
    nullIf(coalesce(traits_phone, customer_phone), '') AS phone_hashed,
    nullIf(customer, '') AS customer,
    nullIf(context, '') AS context,
    nullIf(coalesce(nullIf(properties, ''), nullIf(checkout, ''), nullIf(order, '')), '') AS properties
FROM {{ source_table }}
ORDER BY (original_timestamp, event_name, event_id);
