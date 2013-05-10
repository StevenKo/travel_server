class Api::V1::NotesController < Api::ApiController

  def index
    area_id = params[:area_id]
    order = params[:order]
    notes = nil
    case order.to_i
    when 1
      notes = AreaNoteRelation.joins(:note).where("area_note_relations.area_id = #{area_id}").select("notes.id, notes.title, notes.author,notes.date,notes.pic,notes.read_num").paginate(:page => params[:page], :per_page => 20).order("order_best ASC")
    when 2
      notes = AreaNoteRelation.joins(:note).where("area_note_relations.area_id = #{area_id}").select("notes.id, notes.title, notes.author,notes.date,notes.pic,notes.read_num").paginate(:page => params[:page], :per_page => 20).order("order_new ASC")
    when 3
      notes = AreaNoteRelation.joins(:note).where("area_note_relations.area_id = #{area_id}").select("notes.id, notes.title, notes.author,notes.date,notes.pic,notes.read_num").paginate(:page => params[:page], :per_page => 20).order("read_num DESC")
    end
    render :json => notes
  end

  def nation_group
    nation_group_id = params[:nation_group_id]
    order = params[:order]
    case order.to_i
    when 1
      notes = AreaNoteRelation.joins(:note).where("area_note_relations.nation_group_id = #{nation_group_id}").select("notes.id, notes.title, notes.author,notes.date,notes.pic,notes.read_num").paginate(:page => params[:page], :per_page => 20).order("order_best ASC")
    when 2
      notes = AreaNoteRelation.joins(:note).where("area_note_relations.nation_group_id = #{nation_group_id}").select("notes.id, notes.title, notes.author,notes.date,notes.pic,notes.read_num").paginate(:page => params[:page], :per_page => 20).order("order_new ASC")
    when 3
      notes = AreaNoteRelation.joins(:note).where("area_note_relations.nation_group_id = #{nation_group_id}").select("notes.id, notes.title, notes.author,notes.date,notes.pic,notes.read_num").paginate(:page => params[:page], :per_page => 20).order("read_num DESC")
    end
    notes = unique_relation_notes(notes)
    render :json => notes
  end

  def aboard_hot
    notes = AbordHotNotes.joins(:note).select("notes.id, notes.title, notes.author,notes.date,notes.pic,notes.read_num").paginate(:page => params[:page], :per_page => 20).order("id ASC")
    render :json => notes
  end

  def most_view_notes
    notes = MostViewNote.joins(:note).select("notes.id, notes.title, notes.author,notes.date,notes.pic,notes.read_num").paginate(:page => params[:page], :per_page => 20).order("id ASC")
    render :json => notes
  end

  def new_notes
    notes = NewNote.joins(:note).select("notes.id, notes.title, notes.author,notes.date,notes.pic,notes.read_num").paginate(:page => params[:page], :per_page => 20).order("id ASC")
    render :json => notes
  end

  def best_notes
    notes = BestNote.joins(:note).select("notes.id, notes.title, notes.author,notes.date,notes.pic,notes.read_num").paginate(:page => params[:page], :per_page => 20).order("id ASC")
    render :json => notes
  end

  def show
    note = Note.find(params[:id])
    render :json => note
  end

  def search
    notes = Note.search(params)
    if notes.present?
      ids = notes.map{|item| item["id"]}.join(",")
      @notes = Note.where("id in (#{ids})").select("id,title,author,date,pic,read_num")
      render :json => @notes
    else
      render :json => []
    end
  end

  private 

  def unique_relation_notes(notes)
    hash ={}
    new_notes = notes.reject do |note|
      if hash[note.id]
         true
      else
        hash[note.id] =1
         false
      end
    end
    new_notes
  end
end
