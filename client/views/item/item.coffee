Template.item.inStock = ->
  @quantity > 0

Template.item.rendered = ->
  $('.image-link').magnificPopup({type:'image'})

Template.item.events({
  'click button.purchaseItem': (event) ->
    event.preventDefault()
    purchaseLink = $('button.purchaseItem')
    buttonText = purchaseLink.text()
    purchaseLink.attr('disabled', 'disabled')
    purchaseLink.html('Redirecting to merchant provider...')
    Meteor.call 'purchaseItem', @_id, (error, result) ->
      #TODO: need some error handling
      if result?
        window.location = result
      else
        purchaseLink.removeAttr('disabled')
        purchaseLink.text(buttonText)
})
