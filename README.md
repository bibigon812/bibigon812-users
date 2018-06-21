
# users

This module manages users and their SSH authorized keys.

#### Table of Contents

1. [Description](#description)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)


## Description

It uses the virtual and
realized resources Users::User. All users parameters should be defined for all
nodes in the hash users::virtual. Required users should be listed in the array users::realized for a node.

## Usage

Allow hiera find this module.

```puppet
lookup('classes', Array[String[1]], 'unique', []).include
```

```yaml
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

users::realized:
  - user1
```

## Reference

### Puppet Class: users

#### Summary

This class manages users and their SSH authorized keys.
Overview

It uses the virtual and realized resources Users::User. All users parameters should be defined # for all nodes in the hash users::virtual. Required users should be listed in the array users::realized for a node.

#### Examples

```puppet
include users
```

```yaml
users::virtual:
  user1:
    comment: Test user1
    tag: tag1
    ssh_authorized_keys:
      -
        key: AAAAB3Nza[...]qXfdaQ==
        type: ssh-rsa

users::realized:
  - user1
```

#### Parameters

* virtual (Hash) — All users parameters.

* realized (Array[String[1]]) — List of users or tags to be realized.

### Defined Type: users::user

#### Summary

Manages user and his SSH authorized keys.

#### Overview

This defined type manages user and his SSH authorized keys. It's a proxy for the rsources User and Ssh_authorized_key.

#### Examples

```puppet
auth::user { 'vpupkin':
  comment => 'Vasya Pupkin',
  groups  => ['sudo'],
  ssh_authorized_keys => [
    {
      'key'  => 'AAAAB3Nza[...]qXfdaQ==',
      'type' => 'ssh-rsa',
    },
  ],
}
```

#### Parameters

* ensure (Enum['absent', 'present']) (defaults to: 'present') — The basic state
  that the object should be in. Valid values are present, absent.
* managehome (Boolean) (defaults to: false) — Whether to manage the home
  directory when Puppet creates or removes the user. This creates the home
  directory if Puppet also creates the user account, and deletes the home
  directory if Puppet also removes the user account.

* comment (Optional[String[1]]) (defaults to: undef) — A description of the
  user. Generally the user’s full name.

* gid (Optional[Variant[Integer[0], String[1]]]) (defaults to: undef) —
  The user’s primary group. Can be specified numerically or by name.

* groups (Array[String[1]]) (defaults to: []) — The groups to which the user
  belongs. The primary group should not be listed, and groups should be
  identified by name rather than by GID. Multiple groups should be specified as an array.

* membership (Enum['inclusive', 'minimum']) (defaults to: 'minimum') — If
  minimum is specified, Puppet will ensure that the user is a member of all
  specified groups, but will not remove any other groups that the user is
  a part of. If inclusive is specified, Puppet will ensure that the user is
  a member of only specified groups. Valid values are inclusive, minimum.

* ssh_authorized_keys
  (Array[Struct[{ 'type' => String[1], 'key' => String[1] }]])
  (defaults to: []) — Contains the tuple with ssh type and key.
