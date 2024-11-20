from importer.secobserve_api import Api
from importer.environment import Environment
from requests.exceptions import HTTPError


def check_security_gate():
    try:
        environment = Environment()
        environment.check_environment_common()
        api = Api()
        product = api.get_product()
        if product.get("security_gate_passed") == None:
            print(f"Product {product.get('name')}: Security gate DISABLED")            
            exit(0)

        if product.get("security_gate_passed") == True:
            print(f"Product {product.get('name')}: Security gate PASSED")
            exit(0)

        print(f"Product {product.get('name')}: Security gate FAILED")            
        exit(1)

    except Exception as e:
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        print(f"{e.__class__.__name__}: {str(e)}")
        if isinstance(e, HTTPError):
            print(f"Response: {e.response.content.decode('utf-8')}")
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
        exit(1)


if __name__ == "__main__":
    check_security_gate()
