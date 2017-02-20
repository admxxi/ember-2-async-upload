import Ember from 'ember'

DropZoneComponent = Ember.Component.extend

  removeTimer: null
  showDropZone: false
  dragDropEventHasFiles: (evt) ->
    try
      return evt.dataTransfer.types.contains('Files')
    catch e
      false



  didInsertElement: ->
    # appController = @get('controller')
    # This timer is a HUGE hack that hopefully doesn't bite.
    # We use it to ensure that when the mouse moves over the H2 element,
    # it doesn't cause the dropzone to close.
    $('#global-dropzone h2').on 'dragover', =>
      if @get('removeTimer')
        Ember.run.cancel @get('removeTimer')
      @set 'removeTimer', null



    $('#global-dropzone').on 'click', =>
      @send('removeGlobalDropzone')

    $('body').on 'dragover', (evt) =>
      if @dragDropEventHasFiles(evt)
        if @get('allowFileDrop')
          @send('addGlobalDropzone')

        # If it's a file drop, go a head and eat it to prevent navigation
        return false
      return

    $('body').on 'dragleave', (evt) =>
      if @dragDropEventHasFiles(evt)
        if @get('allowFileDrop') and evt.target.id == 'global-dropzone'
          @set 'removeTimer', Ember.run.later(@send('removeGlobalDropzone'), 1)
        # If it's a file drop, eat it to prevent navigation
        return false
      return

    $('body').on 'drop', (evt) =>

      @send('removeGlobalDropzone')
      if @dragDropEventHasFiles(evt)
        if @get('allowFileDrop')
          @sendAction 'filesDropped', evt.dataTransfer
        # If it's a file drop, eat it to prevent navigation
        return false

  actions:
    addGlobalDropzone: ->
      @set 'showDropZone', true

    removeGlobalDropzone: ->
      @set 'showDropZone', false

export default DropZoneComponent
