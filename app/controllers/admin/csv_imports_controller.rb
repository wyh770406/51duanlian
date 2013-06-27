# encoding: utf-8
require 'csv'

module Admin
  class CsvImportsController < Admin::BaseController
  	def new
  		@csv_import = CsvImport.new
  		@import_type = params[:import_type]
  	end

  	def create
      @csv_import = CsvImport.new(params[:csv_import])
  		uploaded_io = params[:csv_import][:csv]
  		current_gym_name = current_gym.name.gsub(" ","_")
  		import_type = params[:csv_import][:import_type]

  		file_name = "#{current_gym_name}_#{Time.now.strftime('%Y%m%d%H%M')}.csv"
  		file_folder = Rails.root.join('public', "uploads/#{import_type}")

  		if !File.directory?(file_folder)
  			Dir.mkdir(file_folder, 0777)
  		end

      @file = Rails.root.join('public', "uploads/#{import_type}", file_name)

			File.open(@file, 'wb') do |file|
			  file.write(uploaded_io.read)
			end

      @csv_import.csv = uploaded_io.original_filename
      @csv_import.gym = current_gym
      @csv_import.import_type = import_type

      if @csv_import.save
      	case import_type
      	when Card.model_name.human
	      	create_cards(current_gym)
	        redirect_to admin_cards_path
	      when Product.model_name.human
	      	create_products(current_gym)
	        redirect_to admin_products_path
	      else
	      	redirect_to admin_path, notice: "请选择需要导入的模块"
	      end
      else
        render action: "new"
      end

  	end

  	def create_cards(gym)
  		begin
  			creates = 0
	      CSV.read(@file, :headers => true).each do |row|
	      	card_type_name = row[0].strip if row[0]
	      	card_type = gym.card_types.find_by_name(card_type_name)
	      	card_type_id = card_type.id if card_type
	      	default_card_type = gym.card_types.first
	      	default_card_type_id = default_card_type.id if default_card_type

	      	number = row[1].strip if row[1]
	      	username = row[2].strip if row[2]
	      	email = row[3].strip if row[3]
	      	mobile = row[4].strip if row[4]
	      	start_on = Date.parse(row[5]) if row[5]
	      	validity = row[6].to_i if row[6]
	      	balance = row[7].to_d if row[7]

	      	card_info = {
            :card_type_id => card_type_id || default_card_type_id,
	      		:number       => number || "",
	      		:username     => username || "",
	      		:email        => email || "",
	      		:mobile       => mobile || "",
	      		:start_on     => start_on || Date.today,
	      		:validity     => validity || 0,
	      		:company   => gym.company
	      	}

          card = Card.new(card_info)
	        card.current_gym = gym
	        if card.save
            creates += 1
            card_line_item_info = {
            	:reason      => "初次建卡",
            	:amount      => balance || 0.00,
            	:validity    => 0
            }
            card.card_line_items.create(card_line_item_info)
	        else
	        	@errors = card.errors
	        	raise "异常错误，会员卡保存失败."
	        end
	      end
	      logger.info("共创建记录数#{creates}")
	    ensure
	    	FileUtils.rm_f(@file)
	    end
  	end

  	def create_products(gym)
  		begin
  			creates = 0
	      CSV.read(@file, :headers => true).each do |row|
	      	name = row[0].strip if row[0]
	      	sku = row[1].strip if row[1]
	      	price = row[2].to_d if row[2]
	      	count_on_hand = row[3].to_i if row[3]
	      	description = row[4].strip if row[4]

	      	product_info = {
	      		:name                => name || "",
	      		:sku                 => sku || "",
	      		:price               => price || 0.00,
	      		:count_on_hand       => count_on_hand || 0,
	      		:description         => description || "",
	      		:gym                 => gym
	      	}

          product = Product.new(product_info)

	        if product.save
            creates += 1
	        else
	        	@errors = product.errors
	        	raise "异常错误，会员卡保存失败."
	        end
	      end
	      logger.info("共创建记录数#{creates}")
	    ensure
	    	FileUtils.rm_f(@file)
	    end
  	end

  end
end