module ResourceController
  module Actions

    def index
      load_collection
      before :index
      response_for :index
    end

    def show
      load_object
      before :show
      response_for :show
    rescue ActiveRecord::RecordNotFound
      response_for :show_fails
    end

    def create
      build_object
      load_object
     begin
        ActiveRecord::Base.transaction do
          before :create
          object.save!
          after :create
        end
        set_flash :create
        response_for :create
      rescue ActiveRecord::RecordInvalid=>exc
        ActiveRecord::Base.logger.exc exc
        after :create_fails
        set_flash :create_fails
        response_for :create_fails
      end
    end

    def update
      load_object
      before :update
       begin
          ActiveRecord::Base.transaction do
            before :update
            #object.attributes = object_params
            object.update_attributes!(object_params)
            after :update
          end
          set_flash :update
          response_for :update
        rescue ActiveRecord::RecordInvalid
          ActiveRecord::Base.logger.exc
          after :update_fails
          set_flash :update_fails
          response_for :update_fails
        end
    end

    def new
      build_object
      load_object
      before :new_action
      response_for :new_action
    end

    def edit
      load_object
      before :edit
      response_for :edit
    end

    def destroy
      load_object
      begin
        ActiveRecord::Base.transaction do
          before :destroy
          raise ActiveRecord::RecordInvalid.new(object) unless object.destroy
          after :destroy
        end
        set_flash :destroy
        response_for :destroy
      rescue ActiveRecord::RecordInvalid
        ActiveRecord::Base.logger.exc
        after :destroy_fails
        set_flash :destroy_fails
        response_for :destroy_fails
      end
    end

  end
end
