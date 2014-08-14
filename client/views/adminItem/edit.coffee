Template.edit.helpers
  currencies: ->
    gatewayCurrencies = Currencies.findOne({gateway: 'ccex'})
    if gatewayCurrencies?
      return gatewayCurrencies.currencies.map (c) -> { label: c, value: c }
    return []

Template.edit.events({
  'click button.deleteImage': (event, template) ->
    event.preventDefault()
    Meteor.call 'pullAdditionalImage', template.data._id, @, (error, result) ->
      console.log 'cannot delete image', error if error?
    return
})

AutoForm.hooks({
  editForm:
    before:
      update: (docId, modifier, template) ->
        file = $('#titleImage').get(0).files[0]
        if file?
          image = Images.insert(file)
          Meteor.call 'changeTitleImage', docId, image, (error, result) ->
            console.log 'cannot set image', error if error?

        files = $('#additionalImages').get(0).files
        if files.length > 0
          for file in files
            image = Images.insert(file)
            Meteor.call 'pushAdditionalImage', docId, image, (error, result) ->
              console.log 'cannot push additional image', error if error?

        deliveryContent = $('#deliveryContent').get(0).files[0]
        if deliveryContent?
          deliveryFile = DeliveryContent.insert(deliveryContent)
          Meteor.call 'changeDeliveryContent', docId, deliveryFile, (error, result) ->
            console.log 'cannot set delivery content', error if error?

        return modifier
    onError: (operation, error, template) ->
      console.log 'Error', operation, error, template
})

Template.edit.rendered = ->
  $('.image-link').magnificPopup({type:'image'})
