titleImagesStore = new FS.Store.FileSystem('titleImages', {
  path: '~/coinstore/uploads/title_images'
  transformWrite: (fileObj, readStream, writeStream) ->
    transformer = gm(readStream, fileObj.name())
    transformer.size { bufferStream: true }, (error, result) ->
      unless error?
        #check if we have non 4:3 aspect ratio, if we do - we have to crop image to get acceptible results after resize
        if result.width / result.height == 4 / 3
          transformer.resize('400', '300').stream().pipe(writeStream)
        else
          if result.width / 4 * 3 <= result.height
            width = result.width
            height = width / 4 * 3
          else
            height = result.height
            width = height / 3 * 4
          transformer.gravity('Center').extent(width, height).resize('400', '300').stream().pipe(writeStream)
    return
})

fullImagesStore = new FS.Store.FileSystem('fullImages', {
  path: '~/coinstore/uploads/full_images'
  transformWrite: (fileObj, readStream, writeStream) ->
    # downsize image
    gm(readStream, fileObj.name()).resize('1200', '1200').stream().pipe(writeStream)
    return
})

thumbImagesStore = new FS.Store.FileSystem('thumbImages', {
  path: '~/coinstore/uploads/thumb_images'
  transformWrite: (fileObj, readStream, writeStream) ->
    gm(readStream, fileObj.name()).resize('100', '100').stream().pipe(writeStream)
    return
})


@Images = new FS.Collection('images', {
  stores: [fullImagesStore, thumbImagesStore, titleImagesStore]
  filter: {
    allow: {
      contentTypes: ['image/*']
    }
  }
})

@Images.allow({
  insert: (userId, doc) ->
    return userId? and Roles.userIsInRole(userId, ['administrator'])
  update: (userId, doc, fields, modifier) ->
    return userId? and Roles.userIsInRole(userId, ['administrator'])
  remove: (userId, doc) ->
    return userId? and Roles.userIsInRole(userId, ['administrator'])
  download: (userId) ->
    true
})

FS.HTTP.setHeadersForGet([
  ['Cache-Control', 'public, max-age=31536000']
], ['images']);
