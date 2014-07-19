Template.edit.helpers
  imageUrl: ->
    console.log 'imageUrl called, real value', @titleImageUrl
    if @titleImage
      return @titleImage.getFileRecord().url({store: 'titleImages'})

    return null
