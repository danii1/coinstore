Template.item.inStock = ->
  # skip stock check if user pressed buy botton and being redirected to merchant
  purchaseLink = $('button.purchaseItem')
  if purchaseLink? and purchaseLink.text() == 'Redirecting to merchant provider...'
    return true
  # test if we have enough items
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
