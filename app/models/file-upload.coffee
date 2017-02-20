import DS from 'ember-data'

FileUpload = DS.Model.extend

  name: ''
  size: '0 KB'
  rawSize: 0
  isDisplayableImage: false
  base64Image: ''
  fileToUpload: null
  uploadJqXHR: null
  uploadPromise: null
  uploadProgress: null
  isUploading: false
  didUpload: false
  isReading: true
  isAllowed: true

  readFile: (->
    self = this
    @set 'isReading', true
    fileToUpload = @get('fileToUpload')

    isImage = fileToUpload.type.indexOf('image') == 0

    @set 'name', fileToUpload.name
    @set 'rawSize', fileToUpload.size
    @set 'size', fileToUpload.size
    # Don't read anything bigger than 5 MB
    if isImage and fileToUpload.size < 42 * 1024 * 1024
      @set 'isDisplayableImage', isImage
      # Create a reader and read the file.
      reader = new FileReader

      reader.onload = (e) ->
        self.set 'base64Image', e.target.result

      reader.onloadend = (e) =>
        @set 'isReading', false

      # Read in the image file as a data URL.
      reader.readAsDataURL fileToUpload
      self.set 'uploadPromise', Ember.RSVP.defer()
    else
      self.set 'uploadPromise', Ember.RSVP.defer()
      @set 'isReading', false
      @set 'isAllowed', false


    return
  ).observes('fileToUpload')


  uploadFile: ->

    if !@get('isUploading') or !@get('didUpload') or !@get('didError')
      fileToUpload = @get('fileToUpload')
      name = @get('name')
      key = 'public-uploads/' + (new Date).getTime() + '-' + name
      fd = new FormData
      self = this
      fd.append 'key', key
      fd.append 'acl', 'public-read-write'
      fd.append 'success_action_status', '201'
      fd.append 'Content-Type', fileToUpload.type
      fd.append 'file', fileToUpload
      @set 'isUploading', true
      $.ajax(
        url: 'http://localhost:5000/upload'
        type: 'POST'
        data: fd
        processData: false
        contentType: false
        xhr: ->
          xhr = $.ajaxSettings.xhr()
          # set the onprogress event handler

          xhr.upload.onprogress = (evt) ->
            self.set 'progress', evt.loaded / evt.total * 100
            return

          xhr
      ).complete(( jqXHR, textStatus ) ->
        self.set 'isUploading', false
        self.set 'didUpload', true
      ).done((data, textStatus, jqXHR) ->
        self.set 'didUpload', true
        try
          value = JSON.parse(data).message
          self.get('uploadPromise').resolve(JSON.parse(data))
        catch e
          self.get('uploadPromise').resolve(data)

      ).fail (jqXHR, textStatus, errorThrown) ->
        self.set 'didError', true
        try
          debugger;
          value = JSON.parse(jqXHR.responseText).error.code
          self.get('uploadPromise').reject(value)
        catch e
          self.get('uploadPromise').reject(errorThrown)
    @get 'uploadPromise'


  showProgressBar: Ember.computed.or('isUploading', 'didUpload')

  progressStyle: (->
    'width: ' + parseInt(0 + @get('progress')) + '%'
  ).property('progress')






export default FileUpload
