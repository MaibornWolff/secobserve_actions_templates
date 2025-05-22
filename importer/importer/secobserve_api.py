import requests

from importer.environment import Environment


class Api:
    def __init__(self):
        self.environment = Environment()
        self.headers = {
            "accept": "application/json",
            "Content-type": "application/json",
            "Authorization": "APIToken " + self.environment.api_token,
        }
        self.headers_multipart = {
            "accept": "application/json",
            # "Content-Type": "multipart/form-data",
            "Authorization": "APIToken " + self.environment.api_token
        }

    def file_upload_observations(self):
        payload = {
            "product_name": self.environment.product_name,
            "parser_name": self.environment.parser_name,
        }
        if self.environment.branch_name is not None:
            payload["branch_name"] = self.environment.branch_name
        if self.environment.service is not None:
            payload["service"] = self.environment.service
        if self.environment.docker_image_name_tag is not None:
            payload["docker_image_name_tag"] = self.environment.docker_image_name_tag
        if self.environment.endpoint_url is not None:
            payload["endpoint_url"] = self.environment.endpoint_url
        payload["suppress_licenses"] = self.environment.suppress_licenses

        with open(self.environment.file_name, "r") as file:
            file.seek(0)
            files = {
                "file": (
                    self.environment.file_name,
                    file,
                    "application/json",
                )
            }
            response = requests.post(
                self.environment.api_base_url + "/api/import/file_upload_observations_by_name/",
                headers=self.headers_multipart,
                data=payload,
                files=files,
            )
            response.raise_for_status()

            print(response.json())

    def file_upload_sbom(self):
        payload = {
            "product_name": self.environment.product_name,
        }
        if self.environment.branch_name is not None:
            payload["branch_name"] = self.environment.branch_name
        if self.environment.service is not None:
            payload["service"] = self.environment.service

        with open(self.environment.file_name, "r") as file:
            file.seek(0)
            files = {
                "file": (
                    self.environment.file_name,
                    file,
                    "application/json",
                )
            }
            response = requests.post(
                self.environment.api_base_url + "/api/import/file_upload_sbom_by_name/",
                headers=self.headers_multipart,
                data=payload,
                files=files,
            )
            response.raise_for_status()

            print(response.json())

    def get_product(self) -> dict:
        response = requests.get(
            f"{self.environment.api_base_url}/api/products/?name={self.environment.product_name}",
            headers=self.headers,
        )
        response.raise_for_status()

        data = response.json()

        count = data.get("count", None)
        if count == None:
            raise ValueError("Count not found in response")
        if count == 0:
            raise ValueError(f"Product {self.environment.product_name} not found")

        results = data.get("results", [])
        for result in results:
            if result["name"] == self.environment.product_name:
                return result

        raise ValueError(f"Product {self.environment.product_name} not found")
