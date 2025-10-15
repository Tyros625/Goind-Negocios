class AdvertisementModel {
  int? totalSize;
  int? limit;
  int? offset;
  int? all;
  int? running;
  int? pending;
  int? denied;
  int? approved;
  int? expired;
  int? paused;
  List<Adds>? adds;

  AdvertisementModel({
    this.all,
    this.running,
    this.pending,
    this.denied,
    this.approved,
    this.expired,
    this.totalSize,
    this.limit,
    this.offset,
    this.paused,
    this.adds,
  });

  AdvertisementModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'] != null ? int.parse(json['limit'].toString()) : null;
    offset = json['offset'] != null ? int.parse(json['offset'].toString()) : null;
    all = json['all'] != null ? int.parse(json['all'].toString()) : 0;
    running = json['running'] != null ? int.parse(json['running'].toString()) : 0;
    pending = json['pending'] != null ? int.parse(json['pending'].toString()) : 0;
    denied = json['denied'] != null ? int.parse(json['denied'].toString()) : 0;
    approved = json['approved'] != null ? int.parse(json['approved'].toString()) : 0;
    expired = json['expired'] != null ? int.parse(json['expired'].toString()) : 0;
    paused = json['paused'] != null ? int.parse(json['paused'].toString()) : 0;
    if (json['adds'] != null) {
      adds = <Adds>[];
      json['adds'].forEach((v) {
        adds!.add(Adds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    data['all'] = all;
    data['running'] = running;
    data['pending'] = pending;
    data['denied'] = denied;
    data['approved'] = approved;
    data['expired'] = expired;
    data['paused'] = paused;
    if (adds != null) {
      data['adds'] = adds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Adds {
  int? id;
  int? storeId;
  String? addType;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  String? pauseNote;
  String? cancellationNote;
  String? coverImage;
  String? profileImage;
  String? videoAttachment;
  int? priority;
  int? isRatingActive;
  int? isReviewActive;
  int? isPaid;
  int? isUpdated;
  int? createdById;
  String? createdByType;
  String? status;
  int? active;
  String? createdAt;
  String? updatedAt;
  String? coverImageFullUrl;
  String? profileImageFullUrl;
  String? videoAttachmentFullUrl;
  List<Null>? translations;
  List<Storage>? storage;

  Adds({
    this.id,
    this.storeId,
    this.addType,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.pauseNote,
    this.cancellationNote,
    this.coverImage,
    this.profileImage,
    this.videoAttachment,
    this.priority,
    this.isRatingActive,
    this.isReviewActive,
    this.isPaid,
    this.isUpdated,
    this.createdById,
    this.createdByType,
    this.status,
    this.active,
    this.createdAt,
    this.updatedAt,
    this.coverImageFullUrl,
    this.profileImageFullUrl,
    this.videoAttachmentFullUrl,
    this.translations,
    this.storage,
  });

  Adds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    addType = json['add_type'];
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    pauseNote = json['pause_note'];
    cancellationNote = json['cancellation_note'];
    coverImage = json['cover_image'];
    profileImage = json['profile_image'];
    videoAttachment = json['video_attachment'];
    priority = json['priority'];
    isRatingActive = json['is_rating_active'];
    isReviewActive = json['is_review_active'];
    isPaid = json['is_paid'];
    isUpdated = json['is_updated'];
    createdById = json['created_by_id'];
    createdByType = json['created_by_type'];
    status = json['status'];
    active = json['active'] != null ? int.parse(json['active'].toString()) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    coverImageFullUrl = json['cover_image_full_url'];
    profileImageFullUrl = json['profile_image_full_url'];
    videoAttachmentFullUrl = json['video_attachment_full_url'];
    if (json['storage'] != null) {
      storage = <Storage>[];
      json['storage'].forEach((v) {
        storage!.add(Storage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['store_id'] = storeId;
    data['add_type'] = addType;
    data['title'] = title;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['pause_note'] = pauseNote;
    data['cancellation_note'] = cancellationNote;
    data['cover_image'] = coverImage;
    data['profile_image'] = profileImage;
    data['video_attachment'] = videoAttachment;
    data['priority'] = priority;
    data['is_rating_active'] = isRatingActive;
    data['is_review_active'] = isReviewActive;
    data['is_paid'] = isPaid;
    data['is_updated'] = isUpdated;
    data['created_by_id'] = createdById;
    data['created_by_type'] = createdByType;
    data['status'] = status;
    data['active'] = active;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['cover_image_full_url'] = coverImageFullUrl;
    data['profile_image_full_url'] = profileImageFullUrl;
    data['video_attachment_full_url'] = videoAttachmentFullUrl;
    if (storage != null) {
      data['storage'] = storage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Storage {
  int? id;
  String? dataType;
  String? dataId;
  String? key;
  String? value;
  String? createdAt;
  String? updatedAt;

  Storage({
    this.id,
    this.dataType,
    this.dataId,
    this.key,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  Storage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataType = json['data_type'];
    dataId = json['data_id'];
    key = json['key'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['data_type'] = dataType;
    data['data_id'] = dataId;
    data['key'] = key;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
