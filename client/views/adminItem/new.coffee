AutoForm.hooks({
  insertForm:
    onSubmit: (insertDoc, updateDoc, currentDoc) ->
      file = $('#titleImage').get(0).files[0]
      if file?
        image = Images.insert(file)
        insertDoc.titleImage = image
      return true
    onError: (operation, error, template) ->
      console.log 'Error', operation, error, template
})
