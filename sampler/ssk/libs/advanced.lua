-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- Advanced Utilities
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
--
-- =============================================================

local advanced = {}

--[[
h ssk.advanced.addCustom_removeSelf
d Caches a display object's old removeSelf() function and attaches a new one.  This feature allows one display object to have multiple stacked removeSelf() functions that get called in the reverse-order that they were attached.
s ssk.advanced.addCustom_removeSelf( obj, custom_removeSelf)
s * obj - The display object whose removeSelf() function is being cached and stacked.
s * custom_removeSelf - A pointer to the new removeSelf() function to attach to obj.
r None.
--]]

function advanced.addCustom_removeSelf( obj, custom_removeSelf)

	-- If this is the first time, 
	
	if( not obj._cache_removeSelf ) then

		--  A. Create a cache to store custom removeSelf() functions
		obj._cache_removeSelf = {}
		
		--  B. Add the Corona removeSelf function to the cache
		obj._cache_removeSelf[1] = obj.removeSelf

		--  C. Create a custom removeSelf that will call all cached functions and do some other
		--  helpful stuff
		local function removeSelf( self )
			-- 1. Grab the cache of custom removeSelf functions
			local theCache = self._cache_removeSelf
			
			-- 2. Call the custom removeSelf functions in reverse order
			for i=#theCache, 1, -1 do
				self.func = theCache[i]
				if(self.func) then
					self:func()
				end
			end

			-- 3. Clear the cache
			theCache = {}
			self._cache_removeSelf = {}

			-- 4. Assign a dummy catch function which will warn you if removeSelf() is
			--   incorrectly called again
			local function dummy()
				print("WARNING: removeSelf() called twice on same object!" )
			end

			self.removeSelf = dummy
		end

		obj.removeSelf = removeSelf
	end

	obj._cache_removeSelf[#obj._cache_removeSelf+1] = custom_removeSelf
end

return advanced