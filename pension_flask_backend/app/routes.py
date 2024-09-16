from flask import Blueprint, request, jsonify
from app.models import Pension
from app.services import PensionService

routes = Blueprint('routes', __name__)
pension_service = PensionService()

@routes.route('/api/pensions', methods=['GET'])
def get_pensions():
    pensions = pension_service.get_all_pensions()
    return jsonify([p.to_dict() for p in pensions]), 200

@routes.route('/api/pensions/<int:pension_id>', methods=['GET'])
def get_pension(pension_id):
    pension = pension_service.get_pension_by_id(pension_id)
    if pension:
        return jsonify(pension.to_dict()), 200
    else:
        return jsonify({'message': 'Pension not found'}), 404

@routes.route('/api/pensions', methods=['POST'])
def create_pension():
    data = request.get_json()
    if not data:
        return jsonify({'message': 'No input data provided'}), 400
    try:
        pension = pension_service.create_pension(data)
        return jsonify(pension.to_dict()), 201
    except ValueError as e:
        return jsonify({'message': str(e)}), 400

@routes.route('/api/pensions/<int:pension_id>', methods=['PUT'])
def update_pension(pension_id):
    data = request.get_json()
    if not data:
        return jsonify({'message': 'No input data provided'}), 400
    pension = pension_service.update_pension(pension_id, data)
    if pension:
        return jsonify(pension.to_dict()), 200
    else:
        return jsonify({'message': 'Pension not found'}), 404

@routes.route('/api/pensions/<int:pension_id>', methods=['DELETE'])
def delete_pension(pension_id):
    success = pension_service.delete_pension(pension_id)
    if success:
        return jsonify({'message': 'Pension deleted successfully'}), 200
    else:
        return jsonify({'message': 'Pension not found'}), 404