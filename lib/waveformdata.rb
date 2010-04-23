#!/usr/bin/env ruby
require 'rubygems'
require 'gst'
require 'json'

class WaveformData
    def initialize(mp3_filename,wf_filename)
        @mp3_dir = RAILS_ROOT+"/public/uploads/"
        @wf_dir = RAILS_ROOT+"/public/waveform/"
        @filename = mp3_filename
        @output_filename = open(@wf_dir+wf_filename,'w+');
        @output={};
        @output[:waveform] = [];
        @stats={};
        create();
    end

    def create()
        @pipeline = Gst::Pipeline.new
        file_src = Gst::ElementFactory.make("filesrc")
        file_src.location = @mp3_dir+@filename
        decoder = Gst::ElementFactory.make("decodebin")
        audio_convert = Gst::ElementFactory.make("audioconvert")
        audio_level = Gst::ElementFactory.make("level")
        audio_level.name = "level";
        audio_sink = Gst::ElementFactory.make("fakesink")
        @pipeline.add(file_src, decoder, audio_convert, audio_level, audio_sink)
        file_src >> decoder
        audio_convert >> audio_level >> audio_sink
        decoder.signal_connect("new-decoded-pad") do |element, pad|
          sink_pad = audio_convert["sink"]
          pad.link(sink_pad)
        end
        @loop = GLib::MainLoop.new(nil, false)
        @bus = @pipeline.bus
        @bus.add_watch do |bus, message|
          case message.type
          when Gst::Message::EOS
            @loop.quit
            @output[:stats] = @stats
            @output_filename.write(@output.to_json)
            @output_filename.flush
          when Gst::Message::ERROR
            @loop.quit
            return false;
          when Gst::Message::ELEMENT
            s = message.structure 
            if s.name = "level" then
                time = (0.000001*s["timestamp"]).round
                value = (s["peak"][0].abs.round)
                @stats['maxTime'] = time 
                @stats['maxValue'] = value if @stats['maxValue']||0 < value
                @stats['minValue'] = value if (@stats['minValue'].nil? ? true : (@stats['minValue'] > value)) 
                @output[:waveform].push({:time => time, :value => value})
            end    
          end
          true
        end
        @pipeline.play
        begin
          @loop.run
        rescue Interrupt
        ensure
          @pipeline.stop
        end
    end
end
