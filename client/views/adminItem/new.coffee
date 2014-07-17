Template.new.events({
  'click input[type="submit"]': ->
    file = $('#titleImage').get(0).files[0]
    console.log 'got file'
    #fileObj = eventPhotos.insert(file);
    #console.log('Upload result: ', fileObj);
})

AutoForm.hooks({
  insertForm:
    onSubmit: (insertDoc, updateDoc, currentDoc) ->
      console.log 'submitting', insertDoc, updateDoc, currentDoc
      file = $('#titleImage').get(0).files[0]
      if file?
        image = Images.insert(file)
        console.log 'file submitted', image
        insertDoc.titleImage = image
        console.log 'insertDoc', insertDoc
      #console.log 'submitted', file
})
