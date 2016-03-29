# Copyright, 2016, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'trenni/scanner'

module Trenni
	module Markdown
		# This parser processes general markup into a sequence of events which are passed to a delegate.
		class Parser < StringScanner
			def initialize(buffer, delegate)
				super(buffer)
				
				@delegate = delegate
			end

			def parse!
				until eos?
					start_pos = self.pos

					scan_heading
					scan_paragraph

					raise_if_stuck(start_pos)
				end
			end

			protected

			def scan_heading
				# Match any character data except the open tag character.
				if self.scan(/\s*(\#+)\s*(.*?)$/)
					@delegate.heading(self[1].length, self[2])
				end
			end
			
			def scan_paragraph
				if self.scan(/\s*(([^\s].*?\n)+)(\n\n|$)/)
					@delegate.text(self[1].gsub("\n", ' ').strip)
				end
			end
		end
	end
end
