To skip a document of being exported to the ECM system, you can subscribe to the event OnBeforeFindDocDefByRRef in Codeunit "ECM API" and overwrite the finding of the Document Definition which skips further processing of the record.

The Event contains the MainRecordVariant which can be resolved to a RecordRef with the codeunit "Data Type Management".