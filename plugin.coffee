platform = require('os').platform()
{BufferedProcess} = require 'atom'
path = require 'path'

# Code to run in the browser
scripts = {
  js: 'location.reload()'
  css: """
    [].forEach.call(document.getElementsByTagName('link'), function(el){
      var rel = el.getAttribute('rel')
      if (rel && 0 == rel.indexOf('style')) {
        el.parentNode.replaceChild(el.cloneNode(true), el)
      }
    })
  """
}

scripts['md'] =
scripts['html'] =
scripts['jade'] =
scripts['json'] = scripts['js']
scripts['styl'] = scripts['css']

for key, value of scripts
  scripts[key] = {
    type: 'string'
    default: value
  }

plugin = {
  config:
    chrome:
      type: 'boolean'
      order: 1
      default: true
    chromeCanary:
      type: 'boolean'
      order: 1
      default: true
    safari:
      type: 'boolean'
      order: 2
      default: true
    vivaldi:
      type: 'boolean'
      order: 3
      default: true
    scripts:
      type: 'object'
      properties: scripts

  subscriptions: []

  activate: (state) ->
    if platform not of refresh
      return error("#{platform} is not supported")

    @subscriptions.push atom.commands.add '.item-views > atom-text-editor',
      'browser-refresh-on-save:refresh': (event) =>
        scripts = atom.config.get('browser-refresh-on-save.scripts')
        refreshAll(scripts['js'])

    @subscriptions.push atom.workspace.observeTextEditors (editor) =>
      @subscriptions.push editor.onDidSave (event) ->
        scripts = atom.config.get('browser-refresh-on-save.scripts')
        type = path.extname(event.path).slice(1)
        if type of scripts then refreshAll(scripts[type])

  deactivate: ->
    for sub in @subscriptions
      sub.dispose()
    @subscriptions = []
}

error = (message) ->
  atom.notifications.addError("Browser Refresh on Save: #{message}")

MacChromeCmd = """
if (count window of application "Google Chrome") = 0 then return
tell application "Google Chrome"
  set winref to a reference to (first window whose title does not start with "Developer Tools - ")
  set theTab to active tab of winref
  if theTab's URL starts with "http://localhost" or theTab's URL starts with "file:" then
    tell theTab to execute javascript "{js}"
  end if
end tell
"""

MacSafariCmd = """
tell application "Safari" to do JavaScript "{js}" in document 1
"""

commands = {
  darwin: {
    chrome: MacChromeCmd,
    chromeCanary: MacChromeCmd.replace(/Google Chrome/g, "Google Chrome Canary"),
    vivaldi: MacChromeCmd.replace(/Google Chrome/g, "Vivaldi"),
    safari: MacSafariCmd
  }
}

refresh = (browser, js) ->
  refresh[platform](commands[platform][browser], js)

refresh.darwin = (cmd, js) ->
  new BufferedProcess({
    command: 'osascript'
    args: ['-e', cmd.replace('{js}', js)]
    stderr: (data) -> error(data.toString())
  })

refreshAll = (js) ->
  if atom.config.get('browser-refresh-on-save.chrome')
    refresh('chrome', js)
  if atom.config.get('browser-refresh-on-save.chromeCanary')
    refresh('chromeCanary', js)
  if atom.config.get('browser-refresh-on-save.vivaldi')
    refresh('vivaldi', js)
  if atom.config.get('browser-refresh-on-save.safari')
    refresh('safari', js)

module.exports = plugin
