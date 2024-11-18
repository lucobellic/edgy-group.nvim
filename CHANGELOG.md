# Changelog

## [0.5.0](https://github.com/lucobellic/edgy-group.nvim/compare/v0.4.3...v0.5.0) (2024-09-22)


### ⚠ BREAKING CHANGES

* add optional table with position to `open_groups_by_key`

### Features

* add optional table with position to `open_groups_by_key` ([b798fc4](https://github.com/lucobellic/edgy-group.nvim/commit/b798fc45643c95e9b80caa5be57a4ed69d4deffe))

## [0.4.3](https://github.com/lucobellic/edgy-group.nvim/compare/v0.4.2...v0.4.3) (2024-09-19)


### Features

* add `open_groups_by_key` api function ([9bdecf7](https://github.com/lucobellic/edgy-group.nvim/commit/9bdecf77df28800d6999e6a76a98ea635ff28629))

## [0.4.2](https://github.com/lucobellic/edgy-group.nvim/compare/v0.4.1...v0.4.2) (2024-09-01)


### Features

* add highlight for separators ([bd2f077](https://github.com/lucobellic/edgy-group.nvim/commit/bd2f0774a93c34c6a40bc6b1d68547506ec01cfb)), closes [#23](https://github.com/lucobellic/edgy-group.nvim/issues/23)
* remove error for view without open command ([2a3d819](https://github.com/lucobellic/edgy-group.nvim/commit/2a3d819083e3db6080963d54ff34df9fd334dd2d))


### Bug Fixes

* assign key to group without one ([d935115](https://github.com/lucobellic/edgy-group.nvim/commit/d93511595e4ca7110544f7d281e654aca37457c7))

## [0.4.1](https://github.com/lucobellic/edgy-group.nvim/compare/v0.4.0...v0.4.1) (2024-05-08)


### Features

* add get_groups_by_key function ([77c8b56](https://github.com/lucobellic/edgy-group.nvim/commit/77c8b568855074d38d4c1837749fa68839517766))
* add optional toggle option to open_group_index ([c00f4d3](https://github.com/lucobellic/edgy-group.nvim/commit/c00f4d39e8cdc84a91462f0ab24ee841a58ff397))
* add picking function override ([18a4c82](https://github.com/lucobellic/edgy-group.nvim/commit/18a4c82a9f154fdde5debda55349a290daae5f1d))

## [0.4.0](https://github.com/lucobellic/edgy-group.nvim/compare/edgy-group.nvim-v0.3.4...edgy-group.nvim-v0.4.0) (2024-03-20)


### ⚠ BREAKING CHANGES

* rename statusline.lua to init.lua
* rename options.lua to config.lua
* add statusline function and configuration
* update API and opts to look like with edgy

### Features

* add first edgy-group version ([ffdfeaf](https://github.com/lucobellic/edgy-group.nvim/commit/ffdfeafd6b63bf869149d1ad03f4931044d854f6))
* add optional pick key position ([a6c98a7](https://github.com/lucobellic/edgy-group.nvim/commit/a6c98a7e5f599e23854ffdabb4f9b91f47ded484))
* add picking ([c7cfa85](https://github.com/lucobellic/edgy-group.nvim/commit/c7cfa856ab1c01266b6b599f9e894f82bdd4aafa))
* add statusline function and configuration ([d6593f5](https://github.com/lucobellic/edgy-group.nvim/commit/d6593f512258a63b1061eb3103a3f6764909264d))
* add toggle option ([8ae73e0](https://github.com/lucobellic/edgy-group.nvim/commit/8ae73e0b6c0aab8f0bcedc02012950160d2a7d3c))
* add utility functions for group selection ([30d1494](https://github.com/lucobellic/edgy-group.nvim/commit/30d14943cc0afdcfabcfac275166f57f5c3a0592))
* hide pinned windows instead of closing them ([238d56d](https://github.com/lucobellic/edgy-group.nvim/commit/238d56db545c16cc6137505c67bc9c639e9e8d6a))
* support same pick_key for multiple groups ([77baa6f](https://github.com/lucobellic/edgy-group.nvim/commit/77baa6fc6dc602527e7f8b10c5cce02bcf2e64eb))
* update API and opts to look like with edgy ([3a55d67](https://github.com/lucobellic/edgy-group.nvim/commit/3a55d67d06571075149269dd14e43e589e9688d4))


### Bug Fixes

* correct group index ([15e6aed](https://github.com/lucobellic/edgy-group.nvim/commit/15e6aedf42e6c1d80485f60a1fc79f2e88b3b507))
* correct group selection with position ([b9a37b5](https://github.com/lucobellic/edgy-group.nvim/commit/b9a37b5365edf598d6a77ab154b28522e198c4f4))
* do not open views that are already open ([2e998d0](https://github.com/lucobellic/edgy-group.nvim/commit/2e998d0f0ba848fb2c3a22415c3849677ca803cb))
* **statusline:** handle invalid position ([81060eb](https://github.com/lucobellic/edgy-group.nvim/commit/81060eb9e2b9e899971880e827274b348c61d098))


### Code Refactoring

* rename options.lua to config.lua ([ac2e719](https://github.com/lucobellic/edgy-group.nvim/commit/ac2e719d5895e0fb40dfbcf0bdef697c9abd3af4))
* rename statusline.lua to init.lua ([a60b06d](https://github.com/lucobellic/edgy-group.nvim/commit/a60b06dfc03402712a2f644a0373a85e1a47c29a))
