AutoForm.hooks({
  insertForm:
    before:
      insert: (doc, template) ->
        titleImage = $('#titleImage').get(0).files[0]
        if titleImage?
          image = Images.insert(titleImage)
          doc.titleImage = image

        deliveryContent = $('#deliveryContent').get(0).files[0]
        if deliveryContent?
          file = DeliveryContent.insert(deliveryContent)
          doc.deliveryContent = file

        return doc
    onError: (operation, error, template) ->
      console.log 'Error', operation, error, template
})
