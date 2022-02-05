---@alias sqls_subscriber fun(event: dictionary)
---@alias sqls_subscriber_table table<sqls_subscriber, boolean>
---@alias sqls_event_name
---| '"database_choice"'
---| '"connection_choice"'

---@type table<sqls_event_name, sqls_subscriber_table>
local events = {
    database_choice = {},
    connection_choice = {},
}

---@param event_name sqls_event_name
---@param subscriber sqls_subscriber
local function add_subscriber(event_name, subscriber)
    vim.validate{
        event_name = {event_name, 'string'},
        subscriber = {subscriber, 'function'},
    }
    local subscriber_table = events[event_name]
    if not subscriber_table then
        error(('"%s" is not a valid event'):format(event_name))
    end

    subscriber_table[subscriber] = true
end

---@param event_name sqls_event_name
---@param subscriber sqls_subscriber
local function remove_subscriber(event_name, subscriber)
    vim.validate{
        event_name = {event_name, 'string'},
        subscriber = {subscriber, 'function'},
    }
    local subscriber_table = events[event_name]
    if not subscriber_table then
        error(('"%s" is not a valid event'):format(event_name))
    end

    subscriber_table[subscriber] = nil
end

---@param event_name sqls_event_name
---@param event_dictionary dictionary
local function _dispatch_event(event_name, event_dictionary)
    local subscriber_table = events[event_name]
    for subscriber in pairs(subscriber_table) do
        subscriber(event_dictionary)
    end
end

return {
    add_subscriber = add_subscriber,
    remove_subscriber = remove_subscriber,
    _dispatch_event = _dispatch_event,
}
