import Ember from 'ember'

FilesController = Ember.Controller.extend

  uploadedLog: []
  totalFileSize: (->
    total = 0
    console.log @get('model')
    @get('model').forEach (file) ->
      total += file.get('rawSize')
    total
  ).property('model.@each.rawSize')

  hasCompleted: (->
    !!@get('model').findBy('didUpload', true)
  ).property('model.@each.didUpload')

  

  actions:
    removeFile: (file) ->
      @get('model').removeObject file


    removeCompleted: ->
      completed = @get('model').filterBy('didUpload', true)
      @get('model').removeObjects completed


    uploadFile: (file) ->
      uploadedLog = @get('uploadedLog')
      file.uploadFile().promise.then(((url) ->
        uploadedLog.pushObject file.name
      ), (reason) ->
        debugger;
        uploadedLog.pushObject reason
      ).finally ->


    uploadAll: ->
      uploadedLog = @get('uploadedLog')
      @get('model').forEach (item) ->
        item.uploadFile().promise.then(((url) ->
          uploadedLog.pushObject item.name
        ), (reason) ->
          debugger;
          uploadedLog.pushObject reason
        ).finally ->






export default FilesController
