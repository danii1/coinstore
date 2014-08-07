Template.edit.helpers
  currencies: ->
    gatewayCurrencies = Currencies.findOne({gateway: 'ccex'})
    if gatewayCurrencies?
      return gatewayCurrencies.currencies.map (c) -> { label: c, value: c }
    return []

AutoForm.hooks({
  editForm:
    before:
      update: (docId, modifier, template) ->
        file = $('#titleImage').get(0).files[0]
        if file?
          image = Images.insert(file)
          Meteor.call 'changeTitleImage', docId, image, (error, result) ->
            console.log 'cannot set image', error if error?

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
