module Authlogic
  module ActsAsAuthentic
    # Since web applications are stateless there is not sure fire way to tell if a user is logged in or not,
    # from the database perspective. The best way to do this is to provide a "timeout" based on inactivity.
    # So if that user is inactive for a certain amount of time we assume they are logged out. That's what this
    # module is all about.
    module LoggedInStatus
      def self.included(klass)
        klass.class_eval do
          extend Config
          add_acts_as_authentic_module(Methods)
        end
      end
      
      # All configuration for the logged in status feature set.
      module Config
        # The timeout to determine when a user is logged in or not.
        #
        # * <tt>Default:</tt> 10.minutes
        # * <tt>Accepts:</tt> Fixnum
        def logged_in_timeout(value = nil)
          rw_config(:logged_in_timeout, (!value.nil? && value.to_i) || value, 10.minutes.to_i)
        end
        alias_method :logged_in_timeout=, :logged_in_timeout
      end
      
      # All methods for the logged in status feature seat.
      module Methods
        def self.included(klass)
          return if !klass.property_names.include?("last_request_at")
          
          klass.class_eval do
            include InstanceMethods
            
            view_by :logged_in, :map => "function(doc) {
                if (doc['couchrest-type'] == 'User' && doc['last_request_at']) {
                  emit(doc['last_request_at'], null);
                }
              }"
            view_by :logged_out, :map => "function(doc) {
                if (doc['couchrest-type'] == 'User' && doc['last_request_at']) {
                  emit(doc['last_request_at'], null);
                }
              }"

            def self.logged_out
              self.by_logged_out(:endkey => logged_in_timeout.seconds.ago)
            end

            def self.logged_in
              self.by_logged_in(:startkey => logged_in_timeout.seconds.ago)
            end
            
            #named_scope :logged_in, lambda { {:conditions => ["last_request_at > ?", logged_in_timeout.seconds.ago]} }
            #named_scope :logged_out, lambda { {:conditions => ["last_request_at is NULL or last_request_at <= ?", logged_in_timeout.seconds.ago]} }
          end
        end
        
        module InstanceMethods
          
          # Returns true if the last_request_at > logged_in_timeout.
          def logged_in?
            raise "Can not determine the records login state because there is no last_request_at column" if !respond_to?(:last_request_at)
            !last_request_at.nil? && last_request_at > logged_in_timeout.seconds.ago
          end
        
          # Opposite of logged_in?
          def logged_out?
            !logged_in?
          end
        
          private
            def logged_in_timeout
              self.class.logged_in_timeout
            end
        end
      end
    end
  end
end