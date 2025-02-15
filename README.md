# helm-json-schemas-sample

This is a basic sample to explore helm chart validation with `JSON schema`.  
It provides similar capabilities as the required and fail functions but  
can be used to provide more robust Helm input validation with type, pattern, min, max, etc...

The JSON schema needs to be in a file named `values.schema.json`.  
It has to be located alongside with values.yaml file.  

### JSON schema file

```json
{
  "$schema": "https://json-schema.org/draft/2019-09/schema",
  "type": "object",
  "title": "Root Schema",
  "required": [
    "appName",
    "environment",
    "replicasCount",
    "image"
    ],
  "properties": {
    "appName": {
      "type": "string",
      "minLength": 1
    },
    "environment": {
      "type": "string",
      "enum": [
        "dev",
        "tst",
        "prd"
      ]
    },
    "replicasCount": {
      "type": "integer",
      "minimum": 0,
      "maximum": 99
    },
    "image": {
      "type": "object",
      "required": [
        "repository",
        "tag"
      ],
      "properties": {
        "repository": {
          "type": "string",
          "minLength": 1
        },
        "tag": {
          "type": "string",
          "minLength": 1
        }
      }
    }
  }
}
```

### Validation

The schema will be automatically validated when running one of the following commands:

- `helm install`
- `helm upgrade`
- `helm template`
- `helm lint`

### Output example

Using this values file containing several violations of the schema

```yaml
# values-ko.yaml
image:
  repository: "" # an empty string
  tag: 1.2 # int instead of string
appName: # no value provided
environment: foo # unknown environment
replicasCount: "2" # int instead of string
```

```bash
helm template . -f values-ko.yaml

Error: values don't meet the specifications of the schema(s) in the following chart(s):
json-schemas-sample:
- (root): appName is required
- environment: environment must be one of the following: "dev", "tst", "prd"
- replicasCount: Invalid type. Expected: integer, given: string
- image.repository: String length must be greater than or equal to 1
- image.tag: Invalid type. Expected: string, given: number
```

Another example by incorrectly overriding one value using set param

```bash
helm template . --set replicasCount=-1

Error: values don't meet the specifications of the schema(s) in the following chart(s):
json-schemas-sample:
- replicasCount: Must be greater than or equal to 0
```
