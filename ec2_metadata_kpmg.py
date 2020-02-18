from ec2_metadata import EC2Metadata
from ec2_metadata import NetworkInterface
import requests
import re
import json

SERVICE_URL="http://169.254.169.254/latest"

mData={}
jsonItem = ('document','info','ec2-instance')

def merge_dicts(dict1, dict2):
    """ Recursively merges dict2 into dict1 """
    if not isinstance(dict1, dict) or not isinstance(dict2, dict):
        return dict2
    for k in dict2:
        if k in dict1:
            dict1[k] = merge_dicts(dict1[k], dict2[k])
        else:
            dict1[k] = dict2[k]
    return dict1


class GetAllMetadata(EC2Metadata):
    def get_all(self,url=SERVICE_URL):
        data = self._get_url(url).text
        for i in data.splitlines():
            try:
                if re.search(r'^[a-zA-Z0-9\/\-:]+$', i):
                    self.get_all(url+'/'+i)
                else:
                    raise SkippedItem("Item Skipped")
            except Exception as e:
                global mData
                if url.endswith(jsonItem):
                    data = self._get_url(url).json()
                else:
                    data = self._get_url(url).text
                mData = merge_dicts(mData,reduce(lambda res, name: {name: res}, reversed(url.replace('//','/').rstrip('/').split('/')[2:]), data))
                #mData[url]=data
                break

        return mData

    def get_in(self,key,data={}):
        data = self.get_all() if not data else data
        keys = key.split("/")
        try:
            if len(keys) == 1:
                return data[key]
            return self.get_in("/".join(keys[1:]),data[keys[0]])
        except Exception as e:
            print(e)
            return "nil"

def ec2_alldata():
    m = globals()['EC2Metadata']()
    data={}

    for i in [f for f in dir(EC2Metadata) if not f.startswith('_')]:
        if i != 'clear_all':
            data[i]=getattr(m, i)

    interfaces=[]
    networkInterface = [f for f in dir(NetworkInterface) if not f.startswith('_')]
    for mac in data['network_interfaces'].keys():
        n = globals()['NetworkInterface'](mac)
        interface = {}
        interface[mac]={}
        for i in networkInterface:
            if i != 'clear_all':
                interface[mac][i] = getattr(n, i)
        interfaces.append(interface)
    data['network_interfaces'] = interfaces
    return data

if __name__ == "__main__":
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

    
