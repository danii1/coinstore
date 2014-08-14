Template.item.inStock = ->
  # skip stock check if user pressed buy botton and being redirected to merchant
  purchaseLink = $('button.purchaseItem')
  if purchaseLink? and purchaseLink.text() == 'Redirecting to merchant provider...'
    return true
  # test if we have enough items
  @quantity > 0

Template.item.rendered = ->
  # adjust thumbs container width
  imagesNumber = $('.thumbs a').length
  width = imagesNumber * 105
  $('.thumbs-collection').width( width.toString())

  # init gallery
  $('.image-link').magnificPopup({
    type:'image'
    gallery: {
      enabled: true
    }
  })

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
