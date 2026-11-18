<p align="center"><img src="doc/assets/mascot.svg" alt="The tumpel salamander" width="160"></p>

# tumpel infra

This repository holds the OpenTofu configuration for one stage of the tumpel control plane on Cloudflare. It creates the D1 database, the R2 buckets and their event queue, the Access application that guards the browser pages, the stage hostnames under tumpel.dev and the scoped API tokens the Worker uses. The Worker itself lives in [tumpel/control-plane](https://github.com/tumpel/control-plane), and `infra-worker/` is a placeholder Worker that answers every request with 204.
