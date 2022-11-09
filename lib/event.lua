event = {}

function event.next()
    return {computer.pullSignal()}
end

return event