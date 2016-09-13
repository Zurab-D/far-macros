-----------------------------------------------------------------------------
-- raVen's c&c like input 20160913-01
-----------------------------------------------------------------------------
local cccolor = 0xcf;
local pattern = '[%a%d%p%w%s]';

local cx, cy = -1, -1;
Event {
 group = 'EditorInput';
 description = 'command and conquer like input';
 action = function(param)
  if(param.EventType ~= far.Flags.KEY_EVENT) then
   return;
  end;
  if(param.UnicodeChar:match(pattern) == nil) then
   return;
  end;
  local ei = editor.GetInfo();
  if(param.KeyDown) then
   cx = ei.CurPos;
   cy = ei.CurLine;
  else
   editor.Redraw(ei.EditorID);
  end;
 end;
}

Event {
 group = 'EditorEvent';
 description = 'command and conquer like input';
 action = function(eid, event)
  if(event ~= far.Flags.EE_REDRAW) then
   return;
  end;
  if(
   (cx ~= -1) and
   (cy ~= -1)
  ) then
   editor.AddColor(eid, cy, cx, cx, far.Flags.ECF_AUTODELETE, cccolor);
   cx, cy = -1, -1;
  end;
 end;
}
