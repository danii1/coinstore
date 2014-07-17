@Images = new FS.Collection('images', {
  stores: [
    new FS.Store.FileSystem('fullImages', {
      path: '~/uploads/full_images'
      transformWrite: (fileObj, readStream, writeStream) ->
        # downsize image
        gm(readStream, fileObj.name()).resize('1200', '1200').stream().pipe(writeStream)
    })
    new FS.Store.FileSystem('thumbImages', {
      path: '~/uploads/thumb_images'
      transformWrite: (fileObj, readStream, writeStream) ->
        gm(readStream, fileObj.name()).resize('100', '100').stream().pipe(writeStream)
    })
    new FS.Store.FileSystem('titleImages', {
      path: '~/uploads/title_images'
      transformWrite: (fileObj, readStream, writeStream) ->
        gm(readStream, fileObj.name()).resize('400', '300').stream().pipe(writeStream)
    })
  ],
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
