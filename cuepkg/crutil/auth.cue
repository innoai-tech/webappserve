package crutil

import "dagger.io/dagger"

#Auth: {
	username: string
	secret:   dagger.#Secret
}
