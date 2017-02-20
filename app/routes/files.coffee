`import Ember from 'ember'`

FilesRoute = Ember.Route.extend

  model: ->
    []

  allowFileDrop: true

  actions:

    filesDropped: (files) ->
      model = @controller.get('model')

      i = 0
      while i < files.files.length
        fileUploadModel = @store.createRecord('FileUpload',
          {fileToUpload: files.files[i]}
        )
        if fileUploadModel.get('isAllowed')
          model.pushObject fileUploadModel
        else
          fileUploadModel.destroyRecord()

        i++



`export default FilesRoute`
