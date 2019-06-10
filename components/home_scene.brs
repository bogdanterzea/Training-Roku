function init()
	? "[home_scene] init"
	m.category_screen = m.top.findNode("category_screen")
	m.content_screen = m.top.findNode("content_screen")
	m.details_screen = m.top.findNode("details_screen")
	m.content_grid = m.top.findNode("content_grid")

	m.category_screen.observeField("category_selected", "onCategorySelected")
	m.content_screen.observeField("content_selected", "onContentSelected")
	? "FAC CATEGORY TRUE (comedy/drama/horror)"
	m.category_screen.SetFocus(true)
end function

sub onCategorySelected(obj)
  	selected_index = obj.getData()
  	item = m.category_screen.findNode("category_list").content.getChild(selected_index)

  	loadFeed(item.feed_url)
end sub

sub onContentSelected(obj)
	selected_index = obj.getData()
	? selected_index
	item = m.content_screen.findNode("content_grid").content.getChild(selected_index)
	m.details_screen.content = item
	m.content_screen.visible = false
	m.details_screen.visible = true
end sub

sub loadFeed(url)
  	m.feed_task = CreateObject("roSGNode", "load_feed_task")
  	m.feed_task.observeField("response", "onFeedResponse")
  	m.feed_task.url = url
  	m.feed_task.control = "RUN"
end sub

sub onFeedResponse(obj)
	response = obj.getData()
	data = parseJSON(response)
	if data <> Invalid
		? "FAC CONTENT(elementele) TRUE home.brs"
		m.category_screen.visible = false
		m.content_screen.visible = true
		m.content_screen.feed_data = data
		m.content_screen.setFocus(true)
	else
		? "FEED RESPONSE IS EMPTY!"
	end if
end sub

function onKeyEvent(key, press) as Boolean
	if press Then
		if (key = "back")
			if m.content_screen.visible
				? "Acum ai iesit din gridul de obiecte la maniul principal"
				m.content_screen.visible = false
				m.category_screen.visible = true
				m.category_screen.setFocus(true)
				return true
			else if m.details_screen.visible
				? "Ai apasat back din details"

				m.content_screen.visible = true
				m.content_grid.setFocus(true)
				m.details_screen.visible = false
				return true
			end if
		end if
	end if
	return false
end function
