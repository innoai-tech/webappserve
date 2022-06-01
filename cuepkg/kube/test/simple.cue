package test

import (
	"github.com/innoai-tech/runtime/cuepkg/kube"
)

[Context=string]: {
	actual: _
	expect: [Name=string]: true | {[Name=string]: true}
}

{
	"Simple": {
		actual: kube.#App & {
			app: {
				name:    "web"
				version: "alpine"
			}

			services: "\(app.name)": {
				selector: "app": "\(app.name)"
				ports: containers.web.ports
				expose: {
					host: "internal"
					paths: "http": "/"
				}
			}

			containers: "web": {
				image: {
					name: "docker.io/libary/nginx"
					tag:  app.name
				}
				ports: "http": 80
				env: {
					"X": "1"
				}
			}
		}

		expect: "manifests should render": {
			"deployment": actual.kube.deployments.web != _|_
			"services":   actual.kube.services.web != _|_
			"ingress":    actual.kube.ingresses.web != _|_
		}

		expect: "services.web should render": {
			"service.spec.ports should render correct": _|_ != (actual.kube.services.web.spec.ports[0] & {
				name:     "http"
				protocol: "TCP"
				port:     80
			})
		}

		expect: "ingresses.web should render": {
			"ingresses.spec.rules[0] should render correct": _|_ != (actual.kube.ingresses.web.spec.rules[0] & {
				host: "internal"
				http: {
					paths: [{
						pathType: "Exact"
						path:     "/"
						backend: service: {
							name: "web"
							port: name: "http"
						}
					}]
				}
			})
		}

		expect: "containers.web should render": {
			"containers[0].name should be web":          actual.kube.deployments.web.spec.template.spec.containers[0].name == "web"
			"containers[0].ports should render correct": _|_ != (actual.kube.deployments.web.spec.template.spec.containers[0].ports[0] & {
				name:          "http"
				protocol:      "TCP"
				containerPort: 80
			})
			"containers[0].env should render correct": _|_ != (actual.kube.deployments.web.spec.template.spec.containers[0].env[0] & {
				name:  "X"
				value: "1"
			})
		}
	}
}
