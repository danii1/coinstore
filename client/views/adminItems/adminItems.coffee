Template.adminItems.items = ->
  return Items.find()

Template.adminItems.helpers
  formId: ->
    @_id
