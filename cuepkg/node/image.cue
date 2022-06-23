package node

import "github.com/innoai-tech/runtime/cuepkg/debian"

#Image: {
	node: string | *"18"

	debian.#Build & {
		source: "docker.io/library/node:\(node)-\(debian.#Version)"
	}
}
