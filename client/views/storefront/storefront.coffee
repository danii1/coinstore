Template.storefront.items = ->
  return Items.find({quantity: { $gt: 0 }})


Template.storefront.helpers
  itemClasses: ->
    maxCells = Math.floor(12/Meteor.settings.public.itemsInRow)
    mediumCells = Math.floor(12/(Meteor.settings.public.itemsInRow-1))
    classes = 'col-xs-6 col-sm-' + mediumCells.toString() + ' col-md-' + maxCells.toString()
    return classes
