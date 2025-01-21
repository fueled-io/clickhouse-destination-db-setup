# Setting up a ClickHouse Database for Fueled's ClickHouse Destination.

See: [Confluence Documentation](https://fueled-io.atlassian.net/wiki/spaces/ENGINEERIN/pages/334594166/ClickHouse+Events+Destination)

Once the ClickHouse Destination is enabled and events are streaming into an S3 bucket, follow these steps:

1. Create a ClickHouse database specific to the merchant.
2. Create the `canonical_events` table.
3. Create a Materialized View for pushing events into that table.
4. Create the ClickPipe for the merchant. (Note: The ClickPipe should define the raw event table schema.)

Code samples are provided in this repo.