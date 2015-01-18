Lets you organize movies

Example configuration:

    categories:
      - "[c]omedy"
      - "[a]ction"
      - "d[r]ama"

    nodl:
      location: /media/sdb/nodl
      reasons:
        - quality

    mover:
      destinations:
        - "/home/my_account/films"
        - "/media/sda/films"
      tease_location: "/media/sde/trailers"

    scanner:
      tease: true
      nodl: true
      mover: true
      locations:
        - /media/sda/unsorted

    performers:
      tease_location: "/media/sde/trailers"

    remote: http://192.168.1.{{num}}:2000

    processors:
      ffmpeg:
        path: ffmpeg