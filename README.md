# Users

This module manages users and their SSH authorized keys.

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

# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

* [`users`](#users): This class manages users and their SSH authorized keys.

**Defined types**

* [`users::user`](#usersuser): Manages user and his SSH authorized keys.

## Classes

### users

It uses virtual and realized resources Users::User. All users parameters
should be defined for all nodes in the hash users::virtual. Required users
should be listed in the array users::realized for a node.

#### Examples

#####

```puppet
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

The following parameters are available in the `users` class.

##### `virtual`

Data type: `Hash`

All users parameters.

##### `realized`

Data type: `Array[String[1]]`

List of users or tags to be realized.

## Defined types

### users::user

This defined type manages user and his SSH authorized keys. It's a proxy
for the User and Ssh_authorized_key resources.

#### Examples

#####

```puppet
auth::user { 'vpupkin':
  comment => 'Vasya Pupkin',
  groups  => ['sudo'],
  ssh_authorized_keys => [
    {
      'key'     => 'AAAAB3Nza[...]qXfdaQ==',
      'type'    => 'ssh-rsa',
      'comment' => 'my@key',
    },
  ],
}
```

#### Parameters

The following parameters are available in the `users::user` defined type.

##### `ensure`

Data type: `Enum['absent', 'present']`

The basic state that the object should be in.
Valid values are present, absent.

Default value: 'present'

##### `managehome`

Data type: `Boolean`

Whether to manage the home directory when Puppet creates or removes the
user. This creates the home directory if Puppet also creates the user
account, and deletes the home directory if Puppet also removes the user
account.

Default value: `true`

##### `comment`

Data type: `Optional[String[1]]`

A description of the user. Generally the user’s full name.

Default value: `undef`

##### `gid`

Data type: `Optional[Variant[
    Integer[0],
    String[1]
  ]]`

The user’s primary group. Can be specified numerically or by name.

Default value: `undef`

##### `groups`

Data type: `Array[String[1]]`

The groups to which the user belongs. The primary group should not be
listed, and groups should be identified by name rather than by GID.
Multiple groups should be specified as an array.

Default value: []

##### `membership`

Data type: `Enum['inclusive', 'minimum']`

If minimum is specified, Puppet will ensure that the user is a member of
all specified groups, but will not remove any other groups that the user is
a part of. If inclusive is specified, Puppet will ensure that the user is
a member of only specified groups.
Valid values are inclusive, minimum.

Default value: 'minimum'

##### `ssh_authorized_keys`

Data type: `Array[Struct[{
    'type'    => String[1],
    'key'     => String[1],
    'comment' => Optional[String[1]],
  }]]`

Contains an array of structures with the type, key and comment.

Default value: []
