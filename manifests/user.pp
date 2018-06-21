# This defined type manages user and his SSH authorized keys. It's a proxy
# for the rsources User and Ssh_authorized_key.
#
# @summary Manages user and his SSH authorized keys.
#
# @example
#   auth::user { 'vpupkin':
#     comment => 'Vasya Pupkin',
#     groups  => ['sudo'],
#     ssh_authorized_keys => [
#       {
#         'key'  => 'AAAAB3Nza[...]qXfdaQ==',
#         'type' => 'ssh-rsa',
#       },
#     ],
#   }
#
# @param ensure
#   The basic state that the object should be in.
#   Valid values are present, absent.
#
# @param managehome
#   Whether to manage the home directory when Puppet creates or removes the
#   user. This creates the home directory if Puppet also creates the user
#   account, and deletes the home directory if Puppet also removes the user
#   account.
#
# @param comment
#   A description of the user. Generally the user’s full name.
#
# @param gid
#   The user’s primary group. Can be specified numerically or by name.
#
# @param groups
#   The groups to which the user belongs. The primary group should not be
#   listed, and groups should be identified by name rather than by GID.
#   Multiple groups should be specified as an array.
#
# @param membership
#   If minimum is specified, Puppet will ensure that the user is a member of
#   all specified groups, but will not remove any other groups that the user is
#   a part of. If inclusive is specified, Puppet will ensure that the user is
#   a member of only specified groups.
#   Valid values are inclusive, minimum.
#
# @param ssh_authorized_keys
#   Contains the tuple with ssh type and key.
#
define users::user(

  Enum['absent', 'present']    $ensure              = 'present',
  Boolean                      $managehome          = true,
  Optional[String[1]]          $comment             = undef,
  Optional[Variant[
    Integer[0],
    String[1]
  ]]                           $gid                 = undef,
  Array[String[1]]             $groups              = [],
  Enum['inclusive', 'minimum'] $membership          = 'minimum',
  Array[Struct[{
    'type' => String[1],
    'key'  => String[1]
  }]]                          $ssh_authorized_keys = [],

) {
  $home_dir = $title ? {
    'root'  => '/root',
    default => "/home/${title}",
  }

  if $gid {
    group { "${title}-${gid}":
      ensure => $ensure,
      name   => $gid,
      before => User[$title],
    }
  }

  user { $title:
    ensure         => $ensure,
    managehome     => $managehome,
    home           => $home_dir,
    comment        => $comment,
    gid            => $gid,
    groups         => $groups,
    membership     => $membership,
    purge_ssh_keys => empty($ssh_authorized_keys),
  }

  file { "${home_dir}/.ssh":
    ensure  => 'directory',
    mode    => 'o=rwx',
    owner   => $title,
    group   => $gid,
    ignore  => [
      'authorized_keys',
      'authorized_keys2',
      'known_hosts',
      'config',
    ],
    require => User[$title],
  }

  $ssh_authorized_keys.each |$index, $ssh_authorized_key| {
    ssh_authorized_key { "${title}_${index}":
      ensure  => $ensure,
      user    => $title,
      key     => $ssh_authorized_key['key'],
      type    => $ssh_authorized_key['type'],
      require => File["${home_dir}/.ssh"],
    }
  }
}
