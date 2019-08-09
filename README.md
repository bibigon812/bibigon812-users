# Users

This module manages users and their SSH authorized keys.

[![Build Status](https://travis-ci.org/bibigon812/bibigon812-users.svg?branch=master)](https://travis-ci.org/bibigon812/bibigon812-users)

## Usage

Allow hiera find this module.

``` puppet
lookup('classes', Array[String[1]], 'unique', []).include
```

``` yml
classes:
  - users

users::virtual:
  user1:
    comment: Test user1
    tag: tag1
    ssh_authorized_keys:
      -
        key: AAAAB3Nza[...]qXfdaQ==
        type: ssh-rsa
        comment: my@key

users::realized:
  - user1
```
