resource "aws_glue_catalog_database" "landing_page_logs" {
  name = "landing_page_logs"
}

resource "aws_glue_catalog_table" "cloudfront_logs_raw" {
  name          = "cloudfront_logs_raw"
  database_name = aws_glue_catalog_database.landing_page_logs.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    classification           = "cloudfront"
    compressionType          = "gzip"
    typeOfData               = "file"
    "skip.header.line.count" = "2"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.landing_page_logs.bucket}/cloudfront/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "cloudfront-logs-serde"
      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim"            = "\t"
        "serialization.format"   = "\t"
        "skip.header.line.count" = "2"
      }
    }

    columns {
      name = "date"
      type = "date"
    }
    columns {
      name = "time"
      type = "string"
    }
    columns {
      name = "x_edge_location"
      type = "string"
    }
    columns {
      name = "sc_bytes"
      type = "bigint"
    }
    columns {
      name = "c_ip"
      type = "string"
    }
    columns {
      name = "cs_method"
      type = "string"
    }
    columns {
      name = "cs_host"
      type = "string"
    }
    columns {
      name = "cs_uri_stem"
      type = "string"
    }
    columns {
      name = "sc_status"
      type = "int"
    }
    columns {
      name = "cs_referer"
      type = "string"
    }
    columns {
      name = "cs_user_agent"
      type = "string"
    }
    columns {
      name = "cs_uri_query"
      type = "string"
    }
    columns {
      name = "cs_cookie"
      type = "string"
    }
    columns {
      name = "x_edge_result_type"
      type = "string"
    }
    columns {
      name = "x_edge_request_id"
      type = "string"
    }
    columns {
      name = "x_host_header"
      type = "string"
    }
    columns {
      name = "cs_protocol"
      type = "string"
    }
    columns {
      name = "cs_bytes"
      type = "bigint"
    }
    columns {
      name = "time_taken"
      type = "double"
    }
    columns {
      name = "x_forwarded_for"
      type = "string"
    }
    columns {
      name = "ssl_protocol"
      type = "string"
    }
    columns {
      name = "ssl_cipher"
      type = "string"
    }
    columns {
      name = "x_edge_response_result_type"
      type = "string"
    }
    columns {
      name = "cs_protocol_version"
      type = "string"
    }
    columns {
      name = "fle_status"
      type = "string"
    }
    columns {
      name = "fle_encrypted_fields"
      type = "string"
    }
    columns {
      name = "c_port"
      type = "int"
    }
    columns {
      name = "time_to_first_byte"
      type = "double"
    }
    columns {
      name = "x_edge_detailed_result_type"
      type = "string"
    }
    columns {
      name = "sc_content_type"
      type = "string"
    }
    columns {
      name = "sc_content_len"
      type = "bigint"
    }
    columns {
      name = "sc_range_start"
      type = "bigint"
    }
    columns {
      name = "sc_range_end"
      type = "bigint"
    }
  }
}
