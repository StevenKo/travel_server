class Api::V1::NotesController < Api::ApiController
  def index
    area_id = params[:area_id]
    order = params[:order]
    notes = nil
    case order.to_i
    when 1
      notes = Note.where("area_id = #{area_id}").select("id, title, author,date,pic").paginate(:page => params[:page], :per_page => 20).order("order_best ASC")
    when 2
      notes = Note.where("area_id = #{area_id}").select("id, title, author,date,pic").paginate(:page => params[:page], :per_page => 20).order("order_new ASC")
    when 3
      notes = Note.where("area_id = #{area_id}").select("id, title, author,date,pic").paginate(:page => params[:page], :per_page => 20).order("read_num DESC")
    end
    render :json => notes
  end

  def nation_group
    nation_group_id = params[:nation_group_id]
    order = params[:order]
    case order.to_i
    when 1
      notes = Note.where("nation_group_id = #{nation_group_id}").select("id, title, author,date,pic").paginate(:page => params[:page], :per_page => 20).order("order_best ASC")
    when 2
      notes = Note.where("nation_group_id in #{nation_group_id}").select("id, title, author,date,pic").paginate(:page => params[:page], :per_page => 20).order("order_new ASC")
    when 3
      notes = Note.where("nation_group_id in #{nation_group_id}").select("id, title, author,date,pic").paginate(:page => params[:page], :per_page => 20).order("read_num DESC")
    end
    render :json => notes
  end

  def show
    note = Note.find(params[:id])
    render :json => note
  end
end
