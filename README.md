## Challenge 1

A 3 tier environment is a common setup. Use a tool of your choosing/familiarity create these resources. Please remember we will not be judged on the outcome but more focusing on the approach, style and reproducibility.


setup your public key in [terraform.tfvars](terraform/terraform.tfvars)

``` bash
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="eu-west-2"
cd terraform 
terraform init
terraform plan
terraform apply
```

## Challenge 2

 We need to write code that will query the meta data of an instance within aws and provide a json formatted output. The choice of language and implementation is up to you.

Python Way ([ec2_metadata_kpmg.py](ec2_metadata_kpmg.py)):

Please install EC2Metadata via `pip install ec2_metadata`

```python
    ec2_metadata = GetAllMetadata()
    print ("--------------- Whole Json Dump --------------")
    tData = ec2_metadata.get_all()
    print (json.dumps(tData, indent=4, sort_keys=True))

    print ("--------------- Individual Item by get_in() --------------")
    iData = ec2_metadata.get_in('latest/dynamic/instance-identity/document/accountId')
    print (json.dumps(iData, indent=4, sort_keys=True))

    print ("--------------- Individual Item by EC2Metadata --------------")
    print (ec2_metadata.instance_id)

    print ("--------------- All Item's in EC2Metadata --------------")
    print (json.dumps(ec2_alldata(), indent=4, sort_keys=True))
```

shell way :
Only for items in `http://169.254.169.254/latest/dynamic/instance-identity/document`

```bash
#to get all metadata
./ec2_metadata.sh

#To get an item, ex: region
./ec2_metadata.sh region
```

##  Challenge #3

We have a nested object, we would like a function that you pass in the object and a key and get back the value. How this is implemented is up to you.
Example Inputs

```
object = {“a”:{“b”:{“c”:”d”}}}
key = a/b/c

object = {“x”:{“y”:{“z”:”a”}}}
key = x/y/z
value = a
```
### Hints

We would like to see some tests. A quick read to help you along the way

To run test :

`cd get_in && python3 -m unittest` or `cd get_in && python2 test.py`

To run script :

Change the data and key vaule in [get_in.py](get_in/get_in.py) as required and run `cd get_in && ./get_in.py`